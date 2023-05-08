class AddPlanColorToPlans < ActiveRecord::Migration[6.1]
  def change
    add_column :plans, :plan_color, :string
  end
end
