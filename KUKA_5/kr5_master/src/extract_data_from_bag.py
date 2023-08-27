import rosbag

bag_filename = "trajectory_data.bag"  # Reemplaza con el nombre de tu archivo .bag
topic_name = "/arm_controller/state"

velocity_data = []
acceleration_data = []

with rosbag.Bag(bag_filename, "r") as bag:
    for topic, msg, timestamp in bag.read_messages(topics=[topic_name]):
        velocity_data.append(msg.actual.velocities)
        acceleration_data.append(msg.actual.accelerations)

print("velocidad",velocity_data)
print("aceleracion",acceleration_data)
# Ahora puedes usar las listas velocity_data y acceleration_data en tu análisis
