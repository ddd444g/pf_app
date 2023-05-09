module PlansHelper
  def plan_color_class(plan)
    case plan.plan_color
    when "red"
      "bg-red-200"
    when "blue"
      "bg-blue-200"
    when "green"
      "bg-green-200"
    when "purple"
      "bg-purple-200"
    when "yellow"
      "bg-yellow-200"
    else
      nil
    end
  end
end
