require 'spec_helper'

describe "In reply to"  do 

	let(:bart) { FactoryGirl.create(:user, name: 'Bart Simpson', user_name: 'bartman') }
	let(:millhouse) { FactoryGirl.create(:user, name: 'Millhouse Van Houten', 
		user_name: 'millhouse')}
	let(:testmicropost) { FactoryGirl.create(:micropost, user: bart, in_reply_to_id: millhouse.id, 
		                  content: "@millhouse Eat my shorts!") }

	describe "micropost that starts with @username" do 
		before do 
			sign_in bart
			visit root_path ### Home画面
			fill_in 'micropost_content', with: testmicropost.content
			click_button 'Post'
			click_link 'Sign out'
			sign_in millhouse
			visit root_path
		end
		
		it "should appear in recipient's feed" do 
			expect(page).to have_content testmicropost.content
		end

	end

end 