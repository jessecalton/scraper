require 'nokogiri'
require 'open-uri'
require 'pry'

	# attr_accessor :runtime, :title

def set_movie_data(movie_title)
	open_movie_page(movie_title)
	runtime
	title
end

def open_movie_page(title)
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
	@runtime = runtime
end

def title
	@title = @movie.css('title').text.split('(')[0].strip
end

def year
	@year = @movie.css('span#titleYear').text.gsub(/[()]/, '')
end

def metacritic_score
	@metacritic_score = @movie.css('div.metacriticScore').text.strip.to_i
end

# https://www.imdb.com/find?ref_=nv_sr_fn&q=evil+dead&s=tt
# https://www.imdb.com/title/tt0083907/