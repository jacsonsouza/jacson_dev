# frozen_string_literal: true

class Group::FiltersComponent < ViewComponent::Base
  def initialize(model:, filters:)
    super()
    @model = model
    @filters = filters
  end

  def attributes
    [all] + build_attributes
  end

  private

  def build_attributes
    @filters.map do |filter|
      {
        name: filter[0].to_s,
        path: collection_path(@model, category: filter[0].to_s),
        id: filter[0].to_s
      }
    end
  end

  def all
    {
      name: 'All',
      path: polymorphic_path(@model),
      id: 'all'
    }
  end

  def collection_path(record, **)
    helpers.polymorphic_path(record, **)
  end
end
