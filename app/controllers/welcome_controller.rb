class WelcomeController < ApplicationController

  def home
    @voting_round = VotingRound.last
  end

  def vote
    unless (cookies.permanent[:voting_round_id].to_i == VotingRound.last.id.to_i)
      voting_round_question = VotingRoundQuestion.find_by(question_id: params[:question_id])
      voting_round_question.vote_number += 1
      voting_round_question.save
      cookies.permanent[:voting_round_id]=voting_round_question.voting_round_id
      cookies.permanent[:question_id]=voting_round_question.question_id
      redirect_to root_path
    else
      redirect_to root_path, :status => 409 
    end
  end

end
