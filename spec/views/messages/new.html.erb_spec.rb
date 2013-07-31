require 'spec_helper'

describe "messages/new" do
  before(:each) do
    assign(:message, stub_model(Message,
      :content => "MyString",
      :from_user_id => 1,
      :to_user_id => 1
    ).as_new_record)
  end

  it "renders new message form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form[action=?][method=?]", messages_path, "post" do
      assert_select "input#message_content[name=?]", "message[content]"
      assert_select "input#message_from_user_id[name=?]", "message[from_user_id]"
      assert_select "input#message_to_user_id[name=?]", "message[to_user_id]"
    end
  end
end
