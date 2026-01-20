class Users::ProjectsController < Users::BaseController
  before_action :project, except: [:index, :new, :create]

  def index
    @projects = current_user
                .projects.includes([:image_attachment]).order(name: :asc)
  end

  def new
    @project = Project.new
  end

  def edit; end

  def create
    @project = current_user.projects.build(project_params)
    if @project.save
      redirect_to users_projects_path, notice: success_message
    else
      render :new, status: :unprocessable_content
    end
  end

  def update
    if @project.update(project_params)
      redirect_to users_projects_path, notice: success_message
    else
      render :edit, status: :unprocessable_content
    end
  end

  def destroy
    @project.destroy
    redirect_to users_projects_path, notice: success_message
  end

  private

  def project
    @project ||= current_user.projects.find(params[:id])
  end

  def project_params
    params.expect(project: [:name, :short_description,
                            :description, :url, :repository,
                            :favorite, :start_date, :end_date, :image])
  end

  def success_message
    t("notices.#{action_name}", resource: @project.model_name.human)
  end
end
