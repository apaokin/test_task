class UsersController < ApplicationController
  skip_before_filter :verify_authenticity_token

  def create
    @user = User.new create_params
    if @user.save
      render json: { success: true }, status: 200
    else
      nick_errors = @user.errors[:nickname]
      errors = []
      errors.push('NICKNAME_EMPTY') if nick_errors.include?("can't be blank")
      errors.push('NICKNAME_TAKEN') if nick_errors.include?("has already been taken")
      render json: { success: false, errors: errors }, status: 400
    end
  end

  def index
    render json: { success: true, users: User.smart_sort }
  end

  private

  def create_params
    params.permit(:nickname)
  end
end
