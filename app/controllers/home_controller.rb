class HomeController < ApplicationController
  before_action :user, except: [:about, :contact]

  def index; end

  def about; end

  def skills
    @skills = @user.skills.by_category(params[:category])
                   .includes(:icon_attachment).order(name: :asc)
  end

  def projects
    @projects = @user.projects.by_category(params[:category])
                     .includes(:skills)
                     .order(favorite: :desc, name: :asc)
  end

  def project
    @project = Project.find(params[:id])
  end

  def contact
    @message = Message.new
  end

  def submit_contact
    @message = Message.new(message_params)

    if @message.save
      redirect_to contact_path, notice: 'Your message has been sent successfully.'
    else
      flash.now[:alert] = 'There was an error sending your message. Please check the form and try again.'
      render :contact, status: :unprocessable_content
    end
  end

  private

  def user
    @user = User.first
  end

  def message_params
    params.expect(message: [:identity, :email, :subject, :content])
  end
end
