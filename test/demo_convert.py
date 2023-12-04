import os
from scenariogeneration import xosc

if __name__ == '__main__':
    print(f'running {os.path.basename(__file__)}')

    scenario = xosc.ParseOpenScenario("tjunction.xosc")
