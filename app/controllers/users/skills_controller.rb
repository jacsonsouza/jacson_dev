class Users::SkillsController < Users::BaseController
  before_action :skill, except: [:index, :new, :create]

  def index
    @skills = current_user
              .skills.includes([:icon_attachment, :tags]).order(name: :asc)
  end

  def show; end

  def new
    @skill = Skill.new
  end

  def edit; end

  def create
    @skill = current_user.skills.build(skill_params)
    if @skill.save
      redirect_to users_skills_path, notice: success_message
    else
      render :new, status: :unprocessable_content
    end
  end

  def update
    if @skill.update(skill_params)
      redirect_to users_skills_path, notice: success_message
    else
      render :edit, status: :unprocessable_content
    end
  end

  def destroy
    @skill.destroy
    redirect_to users_skills_path, notice: success_message
  end

  private

  def skill
    @skill ||= current_user.skills.find(params[:id])
  end

  def skill_params
    params.expect(skill: [:name, :category, :short_description,
                          :color, :description, :proficiency, :icon, :tag_list])
  end

  def success_message
    t("notices.#{action_name}", resource: @skill.model_name.human)
  end

  def set_breadcrumbs
    add_breadcrumb t('breadcrumbs.skills.index'), users_skills_path

    case action_name.to_sym
    when :new
      add_breadcrumb t('breadcrumbs.skills.new')
    when :edit
      add_breadcrumb t('breadcrumbs.skills.edit', name: @skill.name)
    when :show
      add_breadcrumb @skill.name
    end
  end
end
