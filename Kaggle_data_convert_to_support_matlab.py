import pandas as pd

df = pd.read_csv('train.csv', converters={'POLYLINE': lambda x: json.loads(x)[:]},nrows=1000)
latLong = np.array([])
allTrajectoryLatLong=[p for p in df['POLYLINE'] if len(p)>0]

for oneTrajectoryLatLong in allTrajectoryLatLong:
    oneTrajectory=np.array([[i,oneTrajectoryLatLong[i][0],oneTrajectoryLatLong[i][1]]
                            for i in range(len(oneTrajectoryLatLong))])