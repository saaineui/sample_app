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
        
        unless toc_link.attribute('href').nil? || book.css(toc_link.attribute('href').value).empty?        
          node = book.css(toc_link.attribute('href').value).first
          node = node.parent if node.respond_to?(:parent)
          node = node.next

          until end_of_chapter?(node) do
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
        
        {
          id: index + 1,
          title: get_chapter_title(toc_link),
          text: chapter_text
        }
      end
    end # end if book.respond_to?(:css)

    puts "# Scraped #{item[:title]} - #{item[:url]}"

    item
  end

  def new_book_source_item(row = [])
    url = row.empty? ? '' : row.first
    toc_selector = row.size > 1 ? row.last : 'td a'
    
    item = ScriptsConstants::BOOK_SOURCE_ITEM.dup

    item.merge({
      url: url,
      toc_selector: toc_selector
    })
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
  
  def get_chapter_title(node)
    title = node.text.downcase.titleize 
    title = trim_content(title)
    title.gsub(/chapter\s+\d+\s+/i, '')
  end
  
  def end_of_chapter?(node)
    node.nil? || node.children.any? { |child| child.matches?('a[name]') } ||
      /Project Gutenberg EBook/.match(node.content)
  end
  
  def trim_content(content)
    content.gsub(/^\s+|\s+$/, '')
           .gsub(/\s+/, ' ')
  end

  def skip_node?(node)
    node.content.empty? || node.matches?('h2')
  end
  
  def clean_chapter(chapter_text)
    chapter_text = chapter_text.gsub(/ ?\[.+\]( ?)/, '\1')
  end
end