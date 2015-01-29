require 'rest-client'

  url = RestClient.get "http://gschool.github.io/student-apis/"
  page_object = Nokogiri::HTML(url)
  student_url = page_object.css("a").map do |link|
    link.attr('href')
  end

  student_url.each do |url|
    response = RestClient.get "#{url}/all", :user_agent => 'Chrome'
    movie_hashes = JSON.parse(response)

    movie_hashes.each do |movie_hash|
      Movie.create(
        title: movie_hash["title"],
        year: movie_hash["year"].to_i,
        plot: movie_hash["plot"],
        image_url: movie_hash["image_url"]
      )
    end
  end
