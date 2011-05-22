require 'spec_helper'

class AtomDocWrapper
  include DocWrapper::Base
  include DocWrapper::Properties
  
  namespaces 'atom' => 'http://www.w3.org/2005/Atom'

  class TweetWrapper
    include DocWrapper::Base
    include DocWrapper::Properties
    
    namespaces 'atom' => 'http://www.w3.org/2005/Atom'

    property :twitter_id, :string, './atom:id'
    property :published, :string, './atom:published'
    property :link, :string, './atom:link[@type="text/html"]', :use_attribute => :href
    property :updated, :string, './atom:updated'
    property :author_avatar_link, :string, './atom:link[@type="image/png"]', :use_attribute => :href
    property :author, :string, './atom:author/atom:name'
    property :author_twitter_url, :string, './atom:author/atom:uri'
    property :content_text, :string, './atom:title'
    property :content_html, :string, './atom:content'
  end
  
  has_many :tweets, "//atom:entry", TweetWrapper
end


describe AtomDocWrapper do
  
  let(:doc_string) do
    read_fixture_file('atom_example.xml')
  end
  
  let(:wrapper) do
    AtomDocWrapper.new(Nokogiri::XML(doc_string))
  end
  
  describe "fixture" do
    subject { doc_string }
    it { should match /TWITTER_ID/ }
  end
  
  it "should have 15 tweets" do
    wrapper.tweets.size.should == 15
  end

  describe "first tweet" do
    let(:tweet) do
      wrapper.tweets.first
    end
    
    it { tweet.twitter_id.should == 'TWITTER_ID' }
    it { tweet.published.should == 'PUBLISHED' }
    it { tweet.link.should == 'LINK' }
    it { tweet.updated.should == 'UPDATED' }
    it { tweet.author_avatar_link.should == 'AUTHOR_AVATAR_LINK' }
    it { tweet.author.should == 'AUTHOR' }
    it { tweet.author_twitter_url.should == 'AUTHOR_TWITTER_URL' }
    it { tweet.content_text.should == 'CONTENT_TXT' }
    it { tweet.content_html.should == 'CONTENT_HTML'}
  end
end
