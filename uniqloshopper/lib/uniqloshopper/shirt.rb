class UniqloShopper::Shirt
  
  attr_accessor :name, :price, :url
	
	  @sections = []
	  
	def self.today
	    self.scrape_shirts
	end
  
  def self.scrape_shirts
    shirts = self.scrape_sections

    shirts
  end

  def self.scrape_sections
    if @sections.length == 0
      doc = Nokogiri::HTML(open("https://www.uniqlo.com/us/en/men/t-shirts"))
      doc.css("div.product-tile").each do |section|
        item = {
          :name => section.css("div.product-name a.name-link").text,
          :price => section.css("div.product-pricing span").last.text,
          :url => section.css("div.product-name a.name-link").attribute("href").value
        }
        @sections << item
      end
    end
    @sections
  end


end
