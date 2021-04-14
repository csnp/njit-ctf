resource "aws_appautoscaling_target" "ecs_target" {
  max_capacity       = var.capacity["max"]
  min_capacity       = var.capacity["min"]
  resource_id        = "service/${aws_ecs_cluster.cluster.name}/${aws_ecs_service.backend.name}"
  scalable_dimension = "ecs:service:DesiredCount"
  service_namespace  = "ecs"
}

resource "aws_appautoscaling_policy" "down" {
  name               = "scale-down"
  policy_type        = "StepScaling"
  resource_id        = aws_appautoscaling_target.ecs_target.resource_id
  scalable_dimension = aws_appautoscaling_target.ecs_target.scalable_dimension
  service_namespace  = aws_appautoscaling_target.ecs_target.service_namespace

  step_scaling_policy_configuration {
    adjustment_type         = "ChangeInCapacity"
    cooldown                = 60
    metric_aggregation_type = "Maximum"

    step_adjustment {
      metric_interval_upper_bound = 0
      scaling_adjustment          = -1
    }
  }
}
resource "aws_appautoscaling_policy" "up" {
  name               = "scale-up"
  policy_type        = "StepScaling"
  resource_id        = aws_appautoscaling_target.ecs_target.resource_id
  scalable_dimension = aws_appautoscaling_target.ecs_target.scalable_dimension
  service_namespace  = aws_appautoscaling_target.ecs_target.service_namespace

  step_scaling_policy_configuration {
    adjustment_type         = "ChangeInCapacity"
    cooldown                = 20
    metric_aggregation_type = "Maximum"

    step_adjustment {
      metric_interval_lower_bound = 0
      scaling_adjustment          = 1
    }
  }
}

resource "aws_cloudwatch_metric_alarm" "high" {
  alarm_name          = "${aws_ecs_service.backend.name}-alarm-high"
  alarm_description   = "Alarm monitors high utilization for scaling up"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = 1
  threshold           = 50
  period = 60
  alarm_actions       = [aws_appautoscaling_policy.up.arn]
  statistic = "Average"

  metric_name = "CPUUtilization"
  namespace = "AWS/ECS"
  dimensions = {
    ServiceName = aws_ecs_service.backend.name
    ClusterName = aws_ecs_cluster.cluster.name
  }

  actions_enabled = true

  

  depends_on = [aws_appautoscaling_policy.up]
}

resource "aws_cloudwatch_metric_alarm" "low" {

  alarm_name          = "${aws_ecs_service.backend.name}-alarm-low"
  alarm_description   = "Alarm monitors low utilization for scaling down."
  comparison_operator = "LessThanOrEqualToThreshold"
  evaluation_periods  = 2
  threshold           = 10
  period = 60
  alarm_actions       = [aws_appautoscaling_policy.down.arn]
  statistic = "Average"

  metric_name = "CPUUtilization"
  namespace = "AWS/ECS"
  dimensions = {
    ServiceName = aws_ecs_service.backend.name
    ClusterName = aws_ecs_cluster.cluster.name
  }

  actions_enabled = true



  depends_on = [aws_appautoscaling_policy.down]
}