class Api::V1::AnswersController < Api::ApplicationController
  before_action :authenticate_user!
  before_action :find_answer, :authorize_user!, only: [:destroy]


    def create
      # render json: params
         @post = Post.find params[:post_id]
         @answer = Answer.new answer_params
         @answer.post = @post
         @answer.user = current_user

         if @answer.save
           client = Twilio::REST::Client.new
            client.messages.create({
              from: Rails.application.secrets.twilio_phone_number,
              to: "1#{@post.user.contact_number}",
              body: "message: #{@answer.body} from: #{@answer.user.first_name} Contact info: #{@answer.contact}"
            })

            render json: @post

         else
           @answers = @post.answers.order(created_at: :desc)
           render json: @answers
         end
    end

    def destroy
      @answer.destroy
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
        render json: {errors: "Access Denied"}
      end
    end

  end
