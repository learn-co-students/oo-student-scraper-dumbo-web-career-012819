require 'open-uri'
require 'pry'

class Scraper

  def self.scrape_index_page(index_url)
    html = open(index_url)
    doc = Nokogiri::HTML(html).css(".student-card")
    arr = []
    doc.each do |post|
      arr << {
      :name => post.css(".student-name").text,
      :location => post.css(".student-location").text,
      :profile_url => post.css("a").attribute("href").value
    }
    end
    arr
  end


  def self.scrape_profile_page(profile_url)
    html = open(profile_url)
    doc = Nokogiri::HTML(html)
    profile = {
      :bio => doc.css('.description-holder').first.text.strip,
      :profile_quote => doc.css('.profile-quote').text
    }
    doc.css('.social-icon-container a').each do |icon|
      value = icon.attribute('href').value
      if value.include?("twitter")
        profile[:twitter] = value
      elsif value.include?("github")
        profile[:github] = value
      elsif value.include?("linkedin")
        profile[:linkedin] = value
      else
        profile[:blog] = value
      end
    end
    profile
  end



end
