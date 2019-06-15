require 'nokogiri'
require 'open-uri'
require 'pry'

def movie_page(title)
	base_url = "https://www.imdb.com/find?ref_=nv_sr_fn&q="
	title = title.gsub(/\s/, '+')
    search_data = Nokogiri::HTML(open("#{base_url}#{title}&s=tt"))
    url = search_data.css('table.findList tr:first-child a')[0]['href']
    @movie = Nokogiri::HTML(open("https://www.imdb.com/#{url}"))
end

def runtime
	runtime = 0
	time = @movie.css('time')[0].text.strip.delete('min')

	minutes = time.gsub(/\d*[h]/) {|s| s.delete('h').to_i * 60}
	minutes.split(' ').each {|mins| runtime += mins.to_i}
	@runtime
end


# https://www.imdb.com/find?ref_=nv_sr_fn&q=evil+dead&s=tt
# https://www.imdb.com/title/tt0083907/