class Users::ProjectsController < Users::BaseController
  before_action :project, except: [:index, :new, :create]

  def index
    @projects = current_user.projects
                            .includes([:image_attachment, :skills])
                            .order(favorite: :desc, name: :asc)
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

  def toggle_favorite
    @project.update(favorite: !@project.favorite)

    render partial: 'users/projects/partials/favorite_button',
           locals: { project: @project }
  end

  private

  def project
    @project ||= current_user.projects.find(params[:id])
  end

  def project_params
    params.expect(project: [:name, :short_description, :category,
                            :description, :url, :repository, :details,
                            :favorite, :start_date, :end_date, :image, { skill_ids: [] }])
  end

  def success_message
    t("notices.#{action_name}", resource: @project.model_name.human)
  end

  def set_breadcrumbs
    set_resource_breadcrumbs(
      resource: :project,
      collection_path: users_projects_path,
      instance: @project
    )
  end
end
