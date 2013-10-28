require 'flickrie'

class FlickrService
  def get_api_key
    config = YAML.load_file('config/api-key.yml')
    return config["key"]
  end

  def find_pictures(search_string)
    Flickrie.api_key = get_api_key
    query = {:text => search_string, :license=>"1,2,3,4,5,6", :extras=>['owner_name'], :per_page=>100}
    Flickrie.search_photos(query)
  end
end