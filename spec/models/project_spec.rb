require 'spec_helper'

describe Project do
  it "should be valid from factory" do
    p = Factory(:project)
    p.should be_valid
  end
  it "should get vimeo image URL and store it" do
    p = Factory.build(:project)
    p.stubs(:vimeo).returns({'id' => '1', 'thumbnail_large' => 'http://b.vimeocdn.com/ts/117/614/117614276_200.jpg'})
    p.stubs(:vimeo_id).returns('1')
    p.save!
    p.image_url.should == 'http://b.vimeocdn.com/ts/117/614/117614276_200.jpg'
  end
  it "should have a name" do
    p = Factory.build(:project, :name => nil)
    p.should_not be_valid
  end
  it "should have an user" do
    p = Factory.build(:project, :user => nil)
    p.should_not be_valid
  end
  it "should have a category" do
    p = Factory.build(:project, :category => nil)
    p.should_not be_valid
  end
  it "should have a video URL" do
    p = Factory.build(:project, :video_url => nil)
    p.should_not be_valid
  end
  it "should have an about text" do
    p = Factory.build(:project, :about => nil)
    p.should_not be_valid
  end
  it "should have a headline" do
    p = Factory.build(:project, :headline => nil)
    p.should_not be_valid
  end
  it "should not be valid with a headline longer than 140 characters" do
    p = Factory.build(:project)
    p.headline = "a".center(139)
    p.should be_valid
    p.headline = "a".center(140)
    p.should be_valid
    p.headline = "a".center(141)
    p.should_not be_valid
  end
  it "should have a goal" do
    p = Factory.build(:project, :goal => nil)
    p.should_not be_valid
  end
  it "should have an expires_at date" do
    p = Factory.build(:project, :expires_at => nil)
    p.should_not be_valid
  end
  it "should have a valid Vimeo video URL" do
    p = Factory.build(:project, :video_url => "http://youtube.com/foobar")
    p.should_not be_valid
    p = Factory.build(:project, :video_url => "http://www.vimeo.com/172984359999999")
    p.should_not be_valid
    p = Factory.build(:project, :video_url => "http://vimeo.com/172984359999999")
    p.should_not be_valid
    p = Factory.build(:project, :video_url => "http://www.vimeo.com/17298435")
    p.should be_valid
    p = Factory.build(:project, :video_url => "http://vimeo.com/17298435")
    p.should be_valid
  end
  it "should have a vimeo_id" do
    p = Factory(:project, :video_url => "http://vimeo.com/17298435")
    p.vimeo_id.should == "17298435"
  end
  it "should have a video_embed_url" do
    p = Factory(:project, :video_url => "http://vimeo.com/17298435")
    p.video_embed_url.should == "http://player.vimeo.com/video/17298435"
  end
  it "should be successful if pledged >= goal" do
    p = Factory.build(:project)
    p.goal = 3000.00
    Factory(:backer, :project => p, :value => 2999.99)
    p.successful?.should be_false
    p.backers.destroy_all
    Factory(:backer, :project => p, :value => 3000.00)
    p.successful?.should be_true
    p.backers.destroy_all
    Factory(:backer, :project => p, :value => 3000.01)
    p.successful?.should be_true
  end
  it "should be expired if expires_at is passed" do
    p = Factory.build(:project)
    p.expires_at = 2.seconds.from_now
    p.expired?.should be_false
    p.expires_at = 2.seconds.ago
    p.expired?.should be_true
  end
  it "should be in time if expires_at is not passed" do
    p = Factory.build(:project)
    p.expires_at = 2.seconds.ago
    p.in_time?.should be_false
    p.expires_at = 2.seconds.from_now
    p.in_time?.should be_true
  end
  it "should have a display image" do
    p = Factory(:project)
    p.display_image.should_not be_empty
  end
  it "should have a display about that convers new lines to <br>" do
    p = Factory(:project, :about => "Foo\nBar")
    p.display_about.should == "Foo<br>Bar"
  end
end

