import json
import zipfile
import numpy as np
import pandas as pd
import matplotlib.pyplot as plt


# reading training data

df = pd.read_csv('train.csv', converters={'POLYLINE': lambda x: json.loads(x)[:]},nrows=1000)
latLong = np.array([])
allTrajectoryLatLong=[p for p in df['POLYLINE'] if len(p)>0]

#for oneTrajectoryLatLong in allTrajectoryLatLong:
#    oneTrajectory=np.array([[i,oneTrajectoryLatLong[i][0],oneTrajectoryLatLong[i][1]]
#                            for i in range(len(oneTrajectoryLatLong))])
#
#latlonglist = np.array([i,[p[i][1], p[i][0]] for i in range[p for p in df['POLYLINE'] if len(p)>0]])
#lat_low, lat_hgh = np.percentile(latlong[:,0], [2, 98])
#lon_low, lon_hgh = np.percentile(latlong[:,1], [2, 98])
#
## create image
#bins = 513
#lat_bins = np.linspace(lat_low, lat_hgh, bins)
#lon_bins = np.linspace(lon_low, lon_hgh, bins)
#H2, _, _ = np.histogram2d(latlong[:,0], latlong[:,1], bins=(lat_bins, lon_bins))
#
#img = np.log(H2[::-1, :] + 1)

plt.figure()
for oneTrajectoryLatLong in allTrajectoryLatLong:
    Lats = [p[1] for p in oneTrajectoryLatLong]
    Longs = [p[0] for p in oneTrajectoryLatLong]
    plt.plot(Lats,Longs)

#plt.axis('off')
plt.title('Taxi trip end points')
plt.show()
#plt.savefig("taxi_trip_end_points.png")