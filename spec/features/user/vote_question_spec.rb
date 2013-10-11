require 'spec_helper'

describe "Vote on a question" do
  subject { page }

  before(:each) do
    @question = FactoryGirl.create(:question)
    @question2 = FactoryGirl.create(:question, :other)
    voting_round = FactoryGirl.create(:voting_round)
    voting_round.add_question(@question)
    voting_round.add_question(@question2)
    visit root_path
  end
    
  specify "have vote link" do
    should have_link('vote' + @question.id.to_s)
  end

  context "after voting" do   
    before { click_link('vote' + @question.id.to_s) }

    specify "error when try to vote twice" do
      page.driver.post(vote_path(question_id: @question.id))
      page.driver.status_code.should_not eq 200
    end

    specify "vote icons hidden" do
      should have_no_selector('vote' + @question.id.to_s)
      should have_no_selector('vote' + @question2.id.to_s)
    end

    specify "voted icon displayed next to voted on question" do
      should have_selector('div#vote_confirm' + @question.id.to_s)
    end

  end

  context "new voting round" do
    before do
      click_link('vote' + @question.id.to_s)
      @new_question = FactoryGirl.create(:question, display_text: "hi")
      new_voting_round = FactoryGirl.create(:voting_round, :other)
      new_voting_round.add_question(@new_question)
      visit(current_path)
    end

    specify "have vote link" do
      should have_link('vote' + @new_question.id.to_s)
    end

    specify "voted icon not displayed" do
      should_not have_selector('div#vote_confirm' + @new_question.id.to_s)
    end
  end
end