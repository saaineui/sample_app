require 'csv'
require 'erb'
require 'open-uri'
require 'nokogiri'
require_relative 'scripts_constants'

module BookSourceBot
  module_function

  def generate_files(csv_filename)
    items = scrape_books(csv_filename)

    items.each do |item|
      book_source_file = File.open('lib/scripts/files/book_source_template.html.erb').read
      book_source_file = ERB.new(book_source_file)

      book_source_file_path = "lib/scripts/book_source_files/#{encode_title(item[:title])}.html"

      out_file = File.new(book_source_file_path, "w")
      out_file.puts(book_source_file.result(binding))
      out_file.close

      puts "# #{encode_title(item[:title])}.html has been created"
    end
  end

  def scrape_books(csv_filename)
    headers = []
    items = []

    CSV.foreach("lib/assets/#{csv_filename}.csv").with_index do |row, index|
      item = new_book_source_item(row)
      item = scrape_book(item)

      items << item
    end

    return items
  end

  def scrape_book(item)
    return item if item[:url].nil? || item[:url].empty?

    begin
      book = Nokogiri::HTML(
        open(item[:url])
      )
    rescue OpenURI::HTTPError => http_error
      puts http_error
    rescue StandardError => error
      puts error
    end

    if book.respond_to?(:css)
      item[:title] = get_book_title(book)

      item[:chapters] = book.css(item[:toc_selector]).map.with_index do |toc_link, index|
        chapter_text = ''        
        chapter_start_selector = toc_link_node_to_name_selector(toc_link)
        
        unless chapter_start_selector.nil? || book.css(chapter_start_selector).empty?        
          node = book.css(toc_link.attribute('href').value).first
          node = node.parent if node.respond_to?(:parent)
          node = node.next if node.respond_to?(:next)

          until end_of_chapter?(node, item[:chapter_end_selector]) do
            node.content = trim_content(node.content)

            unless skip_node?(node)
              if chapter_text == ''
                node = node.add_class('first')
                node = node.add_class('first-of-chapter')
              end

              chapter_text += node.to_html + ScriptsConstants::LINE_BREAK
            end

            node = node.next
          end
        end
        
        if item[:toc_selector] == item[:chapter_title_selector]
          chapter_title_node = toc_link
        else
          chapter_title_node = book.css(item[:chapter_title_selector])[index]
        end
        
        {
          id: index + 1,
          title: get_chapter_title(chapter_title_node),
          text: chapter_text
        }
      end
    end # end if book.respond_to?(:css)

    puts "# Scraped #{item[:title]} - #{item[:url]}"

    item
  end

  def new_book_source_item(row = [])
    item = ScriptsConstants::BOOK_SOURCE_ITEM.dup

    row.each_with_index do |val, index|
      case index
      when 0
        item[:url] = val unless val.empty?
      when 1
        item[:toc_selector] = val unless val.empty?
      when 2
        item[:chapter_title_selector] = val unless val.empty?
      end
    end
      
    item
  end
  
  ## helper functions
  def get_book_title(book)
    return 'untitled' if book.css('h1').empty?
    
    title = book.css('h1').first.text.downcase.titleize 
    trim_content(title)
  end
  
  def encode_title(title)
    title.downcase.gsub(/\W/, '-')
  end
  
  def toc_link_node_to_name_selector(toc_link)
    return nil? if toc_link.attribute('href').nil? || toc_link.attribute('href').value.empty?
    
    toc_link.attribute('href').value.gsub(/^#([\w\-]+)$/, '[name="\1"]')
  end
  
  def get_chapter_title(node)
    return 'no title found' if node.nil?
    
    title = trim_content(node.text)
    
    stripped_title = title.gsub(/chapter\s+\d+\s+/i, '')
                          .gsub(/(Chapter\s+)?[IXCDVM]+\.\s+/, '')
    
    title = stripped_title unless stripped_title.empty?
    title.downcase.titleize 
  end
  
  def end_of_chapter?(node, selector)
    node.nil? || node.matches?(selector) || node.children.any? { |child| child.matches?(selector) } ||
      /Project Gutenberg EBook/.match(node.content)
  end
  
  def trim_content(content)
    content.gsub(/^\s+|\s+$/, '')
           .gsub(/\s+/, ' ')
  end

  def skip_node?(node)
    node.content.empty? || node.matches?('h2')
  end
  
  def encode_symbols(text)
    text.gsub(/“/, '&ldquo;')
        .gsub(/”/, '&rdquo;')
        .gsub(/—/, '&mdash;')
  end
  
  def clean_chapter(chapter_text)
    chapter_text = encode_symbols(chapter_text)
    
    # Remove inline styles
    chapter_text = chapter_text.gsub(/style="[\w:; \.\-\(\)]*?"/, '')
    
    # Remove inline page numbers
    chapter_text = chapter_text.gsub(/<span class="pagenum\w?">\d*?<\/span>/, '')
    
    # Remove bracket annotations
    chapter_text = chapter_text.gsub(/ ?\[[^\[\]]+\]( ?)/, '\1')
    
    # Replace headers with italicized paragraph text
    chapter_text = chapter_text.gsub(/<h[1-6][ \w="\-]*?>/, '<p class="buffcenter"><i>')
                               .gsub(/<\/h[1-6]>/, '</i></p>')
    
    # Replace pre with supported text within text
    chapter_text = chapter_text.gsub(/<pre[ \w:="-]+>/, '<div class="wrapper"><p class="pubs">')
                               .gsub(/<\/pre>/, '</p></div>')
    
    # Replace all-caps with italics
    chapter_text = chapter_text.gsub(/([A-Z]{3}[A-Z \-,;\.]+[ \.,;])/) do |match| 
                     # ignore roman numerals
                     if match.match?(/^[ \.,;IVXCDM]+$/)
                       match
                     else
                       space = match.last == ' ' ? ' ' : ''
                       match.gsub($1, "<i>#{match.downcase.titleize}</i>#{space}")
                     end
                   end
  end
end