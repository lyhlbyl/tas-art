

import matplotlib.pyplot as plt
from IPython import display
import numpy as np
# import functions to read xml file and visualize commonroad objects
from commonroad.common.file_reader import CommonRoadFileReader
from commonroad.visualization.mp_renderer import MPRenderer
import copy

def hex_to_RGB(hex_str):
    """ #FFFFFF -> [255,255,255]"""
    #Pass 16 to the integer function for change of base
    return [int(hex_str[i:i+2], 16) for i in range(1,6,2)]

def get_color_gradient(n, c1 = '#FF0000', c2='#000FFF'):
    """
    Given two hex colors, returns a color gradient
    with n colors.
    """
    assert n > 1
    c1_rgb = np.array(hex_to_RGB(c1))/255
    c2_rgb = np.array(hex_to_RGB(c2))/255
    mix_pcts = [x/(n-1) for x in range(n)]
    rgb_colors = [((1-mix)*c1_rgb + (mix*c2_rgb)) for mix in mix_pcts]
    return ["#" + "".join([format(int(round(val*255)), "02x") for val in item]) for item in rgb_colors]



# Yuhui: note the mathplotlib need to be < 3.6. See in the requirements.txt
# generate path of the file to be opened, also the following fix for latent error.
from commonroad.visualization.draw_params import MPDrawParams
# file_path = "./examples/ZAM_Zip-1_35_T-1.xml"
file_path = "./examples/ZAM_Tjunction-1_307_T-1.xml"
if __name__ == '__main__':
    # read in the scenario and planning problem set
    scenario, planning_problem_set = CommonRoadFileReader(file_path).open()
    road = copy.deepcopy(scenario)

    # plt.figure()
    fig, ax = plt.subplots(figsize=(25, 10))

    road.remove_obstacle(road.dynamic_obstacles)
    road.remove_obstacle(road.static_obstacles)
    # plot the scenario for 40 time step, here each time step corresponds to 0.1 second
    for i in range(0, 1):

        rnd = MPRenderer()
        # plot the scenario at different time step

        # Yuhui: following the latest fix from https://gitlab.lrz.de/tum-cps/commonroad-interactive-scenarios/-/commit/1e3911b5b4376c8e30b3986bd0ec63d4f63eabda
        draw_params = MPDrawParams()
        draw_params.time_begin = i
        road.draw(rnd, draw_params=draw_params)

        # plot the planning problem set
        # planning_problem_set.draw(rnd)
        rnd.render()

    # calulate the max time step for color range
    final_ts = 1
    for agent in scenario.dynamic_obstacles:
        final_time_step = agent.prediction.final_time_step
        if final_time_step > final_ts:
            final_ts = final_time_step

    color_idx = get_color_gradient(final_time_step)

    safe_distance = 3
    # plot holes
    for agent in scenario.dynamic_obstacles:
        states = agent.prediction
        t_start = states.initial_time_step
        t_final = states.final_time_step
        trajectory = states.trajectory.state_list
        for pos in trajectory:
            # get color in range
            c = color_idx[pos.time_step - 1]
            hole = plt.Circle((pos.position[0],pos.position[1]), safe_distance, color=c, zorder=10)
            ax.add_artist(hole)
    plt.show()
