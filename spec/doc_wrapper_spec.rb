require 'spec_helper'

describe DocWrapper do

  describe "The wrapped test documents" do
    let(:doc1) do
      Nokogiri::HTML(read_fixture_file("doc_wrapper_test.html"))
    end
    
    let(:doc2) do
      Nokogiri::HTML(read_fixture_file("doc_wrapper_test_2.html"))
    end
    
    let(:document) do
      TestDocWrapper.new([ doc1, doc2 ])
    end
    
    describe "#properties" do
      let(:document_properties) do
        document.properties
      end
      
      it { document_properties[:paragraph].should == 'A paragraph' }
      it "should strip HTML &nbsp; from string properties" do
        pending
        document_properties[:space_example].should == 'Space Example'
      end
      it { document_properties[:active].should be_true }
      it { document_properties[:date].should == Date.parse('12-Dec-2009') }
      it { document_properties[:date_with_block].should == 'result from block' }
      it { document_properties[:time].should == Time.parse('12-Dec-2009 12:31 PM') }
      it { document_properties[:parsed_date].should == Date.parse('12-Dec-2009') }
      it { document_properties[:parsed_time].should == Time.parse('12-Dec-2009 12:31 PM') }
      it { document_properties[:table_data].should == 'A table data' }
      it { document_properties[:paragraph2].should == 'A second paragraph' }
      it { document_properties[:combined_tds].should == 'A table data A table data' }
      it { document_properties[:combined_date_and_time].should == Time.parse('12-Dec-2009 12:31 PM') }
      it { document_properties[:arrayed_xpath].should == 'name1 position1 salary1' }
      it { document_properties.size.should == 14 }
    end

    it { document.should respond_to(:paragraph) }
    it { document.should respond_to(:table_data) }
    it { document.should respond_to(:date) }
    it { document.should respond_to(:parsed_date) }
    it { document.should respond_to(:combined_tds) }
    it { document.should respond_to(:combined_date_and_time) }
    it { document.should respond_to(:arrayed_xpath) }

    it { document.paragraph.should == 'A paragraph' }
    it { document.paragraph2.should == 'A second paragraph' }
    it { document.table_data.should == 'A table data' }
    it { document.date.should == Date.parse('12-Dec-2009') }
    it { document.parsed_date.should == Date.parse('12-Dec-2009') }
    it { document.date_with_block.should == 'result from block' }
    it { document.active.should == true }
    it { document.time.should == Time.parse('12-Dec-2009 12:31 PM') }
    it "should strip HTML &nbsp; from string properties" do
      pending
      document.space_example.should == 'Space Example'
    end
    it { document.combined_tds.should == 'A table data A table data' }
    it { document.combined_date_and_time.should == Time.parse('12-Dec-2009 12:31 PM') }
    it { document.arrayed_xpath.should == 'name1 position1 salary1' }
    it { document.raw_property.should == 'raw' }
    it { document.line_items.size.should == 4 }
    
    describe "paragraph_wrapper" do
      let(:paragraph_wrapper) do
        document.paragraph_wrapper
      end
      
      it { paragraph_wrapper.paragraph.should == 'A paragraph'}
    end
    
    describe "line item 0" do
      let(:line_items) do
        document.line_items[0]
      end
      
      it { line_items.name.should == 'name1' }
      it { line_items.position.should == 'position1' }
      it { line_items.salary.should == 'salary1' }
    end
    
    describe "line item 1" do
      let(:line_items) do
        document.line_items[1]
      end
      
      it { line_items.name.should == 'name2' }
      it { line_items.position.should == 'position2' }
      it { line_items.salary.should == 'salary2' }
    end
    
    describe "has_one person" do
      let(:person) do
        document.person
      end
      
      it { person.name.should == 'Mark Menard' }
      it { person.home_town.should == 'Troy, NY' }
    end
    
  end
end

class TestDocLineItem
  include DocWrapper::Base
  include DocWrapper::Properties

  property :name, :string, "./td[1]"
  property :position, :string, "./td[2]"
  property :salary, :string, "./td[3]"

end

class PersonWrapper
  include DocWrapper::Properties
  include DocWrapper::Base
  
  property :name, :string, "./p[1]"
  property :home_town, :string, "./p[2]"
end

class ParagraphWrapper
  include DocWrapper::Properties
  include DocWrapper::Base
  
  property :paragraph, :string, '.'
end

class TestDocWrapper
  include DocWrapper::Properties
  include DocWrapper::Base

  property :paragraph, :string, "/html/body/p[1]"
  has_one :paragraph_wrapper, "/html/body/p[1]", ParagraphWrapper
  property :space_example, :string, "/html/body/p[5]" do |x|
    x.strip
  end
  property :active, :boolean, "/html/body/p[2]", :parser => lambda { |x| x == 'Yes' }
  property :date, :date, "/html/body/p[3]"
  property :parsed_date, :date, "/html/body/p[3]", :parser => lambda { |x| Date.parse(x) }
  property :date_with_block, :date, "/html/body/p[3]" do |x| 
    "result from block"
  end
  property :time, :time, "/html/body/p[4]"
  property :parsed_time, :time, "/html/body/p[4]", :parser => lambda { |x| Time.parse(x) }
  property :table_data, :string, "/html/body/table[1]/tr/td[1]"
  property :paragraph2, :string, "/html/body/p[1]", :document => 2
  has_many :line_items, "/html/body/table[2]/tr", TestDocLineItem, :start_row => 1, :end_row => 4
  multi_property :combined_tds, ["/html/body/table[1]/tr/td[1]", "/html/body/table[1]/tr/td[1]"] do |elements|
    elements.join(" ")
  end
  multi_property :combined_date_and_time, ["/html/body/p[6]", "/html/body/p[7]"] do |elements|
    Time.parse(elements.join(" "))
  end
  
  # Example of a multi_property that uses an XPath that returns an array of elements.
  multi_property :arrayed_xpath, ["/html/body/table[2]/tr[2]/td"] do |elements|
    elements.join(" ")
  end
  property :raw_property, :raw, "/html/body/p[8]" do |ns|
    ns[0].attribute("class").inner_html
  end
  
  has_one :person, "/html/body/div", PersonWrapper
end
