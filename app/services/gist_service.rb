class GistService
  def initialize(link, client = default_client)
    @link = link
    @client = client
    @gist = get_gist
  end

  def content
    if @errors.nil?
      @gist.files.map { |_, g| [g.filename, g.content] }
    else
      [[@link.name, 'Gist not found']]
    end
  end

  private

  def get_gist
    @client.gist(gist_id)
  rescue Octokit::NotFound => @errors
  end

  def gist_id
    @link.url.split('/').last
  end

  def default_client
    Octokit::Client.new
  end
end
