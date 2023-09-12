### Autoscalling group min, desired and max capacity
When you expect AWS to scale lower than your Desired if desired is larger than Min?

This happens when you set a CloudWatch alarm based on some AutoScaling policy. Whenever that alarm is triggered it will update the DesiredCount to whatever is mentioned in config.

e.g., If an AutoScalingGroup config has Min=1, Desired=3, Max=5 and there is an Alarm set on an AutoScalingPolicy which says if CPU usage is <50% for consecutive 10 mins then Remove 1 instances then it will keep reducing the instance count by 1 whenever the alarm is triggered until the DesiredCount = MinCount.

Lessons Learnt: Set the MinCount to be > 0 or = DesiredCount. This will make sure that the application is not brought down when the mincount=0 and CPU usage goes down.

#### MIN: 
This will be the minimum number of instances that can run in your auto scale group. If your scale down CloudWatch alarm is triggered, your auto scale group will never terminate instances below this number

#### DESIRED: 
If you trip a CloudWatch alarm for a scale up event, then it will notify the auto scaler to change it's desired to a specified higher amount and the auto scaler will start an instance/s to meet that number. If you trip a CloudWatch alarm to scale down, then it will change the auto scaler desired to a specified lower number and the auto scaler will terminate instance/s to get to that number.
The desired capacity must be equal to or greater than the minimum group size, and equal to or less than the maximum group size. Desired capacity: Represents the initial capacity of the Auto Scaling group at the time of creation. An Auto Scaling group attempts to maintain the desired capacity.

#### MAX: 
This will be the maximum number of instances that you can run in your auto scale group. If your scale up CloudWatch alarm stays triggered, your auto scale group will never create instances more than the maximum amount specified.

#### From AWS documentation
https://docs.aws.amazon.com/autoscaling/ec2/userguide/asg-capacity-limits.html

The group's desired capacity can be resized to a number that's within the range of your minimum and maximum size limits. The desired capacity must be equal to or greater than the minimum group size, and equal to or less than the maximum group size.

Desired capacity: Represents the initial capacity of the Auto Scaling group at the time of creation. An Auto Scaling group attempts to maintain the desired capacity. It starts by launching the number of instances that are specified for the desired capacity, and maintains this number of instances as long as there are no scaling policies or scheduled actions attached to the Auto Scaling group.

Minimum capacity: Represents the minimum group size. When scaling policies are set, an Auto Scaling group cannot decrease its desired capacity lower than the minimum size limit.

Maximum capacity: Represents the maximum group size. When scaling policies are set, an Auto Scaling group cannot increase its desired capacity higher than the maximum size limit.

