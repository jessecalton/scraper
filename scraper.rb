require 'nokogiri'
require 'open-uri'
require 'pry'

	# attr_accessor :runtime, :title

def set_movie_data(movie_title)
	open_movie_page(movie_title)
	runtime
	title
	director
	stars
	poster_url
end

# Searches movie title and opens movie page in Nokogiri
def open_movie_page(title)
	base_url = "https://www.imdb.com/find?ref_=nv_sr_fn&q="
	title = title.gsub(/\s/, '+')
    search_data = Nokogiri::HTML(open("#{base_url}#{title}&s=tt"))
    url = search_data.css('table.findList tr:first-child a')[0]['href']
    @movie = Nokogiri::HTML(open("https://www.imdb.com/#{url}"))
end

# Returns movie runtime in minutes as an integer
def runtime
	runtime = 0
	time = @movie.css('time')[0].text.strip.delete('min')

	minutes = time.gsub(/\d*[h]/) {|s| s.delete('h').to_i * 60}
	minutes.split(' ').each {|mins| runtime += mins.to_i}
	@runtime = runtime
end

# Returns movie title
def title
	@title = @movie.css('title').text.split('(')[0].strip
end

# Returns movie year
def year
	@year = @movie.css('span#titleYear').text.gsub(/[()]/, '')
end

# Returns metacritic score as integer
def metacritic_score
	@metacritic_score = @movie.css('div.metacriticScore').text.strip.to_i
end

# Returns an array or director or directors
def director
	director_glob = @movie.css('div.plot_summary div.credit_summary_item')[0].text.gsub("\n", '')
	if director_glob.include?('Directors:')
		@director = director_glob.gsub('Directors:', '').strip.split(',').map{|dir| dir.split('(').first.strip}
	else
		@director = [director_glob.split('Director').last.strip.gsub(':', '')]
	end
end

# Returns an array of headline actors
def stars
	@stars = @movie.css('div.plot_summary div.credit_summary_item').last.text.gsub("\n", '')
		.split('|').first.strip.gsub('Stars:', '').split(',').map{|star| star.strip}
end

# Sets poster url 
def poster_url
	@poster_url = @movie.css('div.poster img').attribute('src').value
end

# https://www.imdb.com/find?ref_=nv_sr_fn&q=evil+dead&s=tt
# https://www.imdb.com/title/tt0083907/