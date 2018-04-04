class AnswersController < ApplicationController
  before_action :authenticate_user!
    before_action :find_answer, :authorize_user!, only: [:destroy]


    def create
         @post = Post.find params[:post_id]
         @answer = Answer.new answer_params
         @answer.post = @post
         @answer.user = current_user

         if @answer.save
           client = Twilio::REST::Client.new
            client.messages.create({
              from: Rails.application.secrets.twilio_phone_number,
              to: "1#{@post.user.contact_number}",
              body: "Reply: #{@answer.body} from: #{@answer.user.first_name} Contacted by: #{@answer.contact}"
            })

           redirect_to post_path(@post)
         else
           @answers = @post.answers.order(created_at: :desc)
           render 'posts/show'
         end
    end

    def destroy
      answer = Answer.find params[:id]
      answer.destroy
      redirect_to post_path(answer.post)
    end

    private
    def answer_params
      params.require(:answer).permit(:body, :contact)
    end

    def find_answer
    @answer ||= Answer.find params[:id]
    end

    def authorize_user!
      unless can?(:manage, @answer)
        flash[:alert] = "Access Denied"
        redirect_to product_path(@answer.post)
      end
    end

  end
