require 'csv'
require 'erb'
require 'open-uri'
require 'nokogiri'
require_relative 'scripts_constants'

module BookSourceBot
  module_function

  def scrape_posts(filename)
    headers = []
    items = []

    CSV.foreach("lib/assets/#{filename}.csv").with_index do |row, index|
      url = row.first
      item = new_book_source_item(url)
      item = scrape_post(item)

      puts "# Post #{url} has been normalized"

      items << item
    end

    return items
  end

  def generate_import_files(codes, source_url)
    items = scrape_posts(codes[:country])

    posts_erb = File.open('templates/posts.xml.erb').read
    posts_erb = ERB.new(posts_erb)

    num_import_files = items.length / Constants::MAX_POSTS_PER_IMPORT_FILE + 1

    (1..num_import_files).each do |file_index|
      import_file_path = "import_files/sl_posts_#{codes[:country]}_#{file_index}.xml"
      items_set_start = (file_index - 1) * Constants::MAX_POSTS_PER_IMPORT_FILE
      items_set_end = num_import_files == file_index ? -1 : file_index * Constants::MAX_POSTS_PER_IMPORT_FILE - 1
      items_set = items[items_set_start..items_set_end]

      out_file = File.new(import_file_path, "w")
      out_file.puts(posts_erb.result(binding))
      out_file.close

      puts "# #{import_file_path} has been created"
    end
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
      bookmeta = {
        title: '',
        chapters: [],
      }

      item[:title] = get_book_title(book)

      item[:chapters] = book.css('.toc a').map.with_index do |toc_link, index|
        chapter_text = ''
        
        chapter_anchor = book.css(toc_link.attribute('href').value).first unless toc_link.attribute('href').nil?
        
        node = chapter_anchor.parent.next
        
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
        
        {
          id: index + 1,
          title: get_chapter_title(toc_link),
          text: chapter_text
        }
      end
    end # end if book.respond_to?(:css)

    puts "# Scraped #{item[:url]}"

    item
  end

  def new_book_source_item(url = '')
    item = ScriptsConstants::BOOK_SOURCE_ITEM.dup

    item.merge({
      url: url
    })
  end
  
  ## helper functions
  def get_book_title(book)
    return '' if book.css('h1').empty?
    
    title = book.css('h1').first.text.downcase.titleize 
    trim_content(title)
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
end