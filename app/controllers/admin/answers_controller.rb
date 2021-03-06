=begin
Copyright 2013 WBEZ
This file is part of Curious City.

Curious City is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.

Curious City is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for more details.

You should have received a copy of the GNU General Public License along with Curious City.  If not, see <http://www.gnu.org/licenses/>.
=end
module Admin
  class AnswersController < Admin::AdminController
    before_action :load_answers_and_updates, only: [:index, :destroy, :reorder]
    before_action :admin_privilege_check, only: [:edit, :new, :reorder, :destroy]

    def index
      @question = Question.find(params[:question_id])
    end

    def edit
        @answer = Answer.find(params[:id])
    end

    def update
      @answer = Answer.find(params[:id])
      if @answer.update_attributes(answer_params)
        redirect_to(admin_answers_url(question_id: params[:answer][:question_id]))
      else
        render "edit"
      end
    end

    def new
        params.require(:question_id)
        @answer = Answer.new(question_id: params[:question_id])
    end

    def reorder
    end

    def sort
      params[:answer].each_with_index do |id, index|
        Answer.find(id).insert_at(index+1)
      end
      render nothing: true
    end

    def create
      @answer = Answer.new(answer_params)
      if @answer.save
        redirect_to(admin_answers_url(question_id: @answer.question_id))
      else
        render "new"
      end
    end

    def destroy
        answer = Answer.find(params[:id])
        @question = Question.find(params[:question_id])
        answer.destroy
        render "index"
    end

    private
      def load_answers_and_updates
        params.require(:question_id)
        ordered_answers_both_types = Question.find(params[:question_id]).answers.order(:position)
        @answers = ordered_answers_both_types.where(type: Answer::Type::Answer)
        @updates = ordered_answers_both_types.where(type: Answer::Type::Update)
      end

      def answer_params
        params.require(:answer).permit(:label, :url, :question_id, :type)
      end
  end
end
