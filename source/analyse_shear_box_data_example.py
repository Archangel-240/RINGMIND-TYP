"""Example script showing how to read and plot shearing box data
"""
from typing import List, Tuple

import numpy as np
import matplotlib.pyplot as plt


class RingmindShearingBoxData:
    """Simple container for data saved by the Ringmind Shearing Box

    Attributes
    ----------
    _raw_data: np.ndarray
        Structured array containing the raw data loaded from the CSV file.

    _max_id: int
        The maximum particle id in the file.
    """

    def __init__(self):
        """Initialise
        """
        self._raw_data = None
        self._max_id = None

    def load_particles(self, filename: str):
        """Load particle data from a CSV file into this class.

        Parameters
        ----------
        filename : str
            Filename of the file to load.
        """
        self._raw_data = np.loadtxt(filename, dtype=np.dtype([("time",float),("id",int),("x",float),("y",float),("z",float)]),
                                        delimiter=",", skiprows=1)
        self._max_id = np.max(self._raw_data["id"])

    @property
    def raw_data(self) -> np.ndarray:
        """Access the raw numpy array of data loaded from the file.

        Returns
        -------
        np.ndarray
            Structured array of data.
        """
        return self._raw_data

    def get_x_by_id(self, id: int) -> np.ndarray:
        """Get the x position for the particle with a given id

        Parameters
        ----------
        id : int
            Id number of the particle to return data for.

        Returns
        -------
        np.ndarray
            X coordinates.
        """
        return self._raw_data["x"][self._raw_data["id"]==id]

    def get_y_by_id(self, id: int) -> np.ndarray:
        """Get the y position for the particle with a given id

        Parameters
        ----------
        id : int
            Id number of the particle to return data for.

        Returns
        -------
        np.ndarray
            Y coordinates.
        """
        return self._raw_data["y"][self._raw_data["id"]==id]

    def get_z_by_id(self, id: int) -> np.ndarray:
        """Get the z position for the particle with a given id

        Parameters
        ----------
        id : int
            Id number of the particle to return data for.

        Returns
        -------
        np.ndarray
            Z coordinates.
        """
        return self._raw_data["z"][self._raw_data["id"]==id]

    def get_time_by_id(self, id: int) -> np.ndarray:
        """Get the time data for the particle with a given id

        Parameters
        ----------
        id : int
            Id number of the particle to return data for.

        Returns
        -------
        np.ndarray
            Times.
        """
        return self._raw_data["time"][self._raw_data["id"]==id]
    

    def get_moonlet_x(self) -> np.ndarray:
        """Get the x position for the moonlet

        Returns
        -------
        np.ndarray
            X coordinates.
        """
        return self.get_x_by_id(-1)

    def get_moonlet_y(self) -> np.ndarray:
        """Get the y position for the moonlet

        Returns
        -------
        np.ndarray
            Y coordinates.
        """
        return self.get_y_by_id(-1)

    def get_moonlet_z(self) -> np.ndarray:
        """Get the z position for the moonlet

        Returns
        -------
        np.ndarray
            Z coordinates.
        """
        return self.get_z_by_id(-1)

    def get_moonlet_time(self) -> np.ndarray:
        """Get the time data for the moonlet

        Returns
        -------
        np.ndarray
            Times.
        """
        return self.get_time_by_id(-1)

    def __iter__(self) -> Tuple[np.ndarray, np.ndarray, np.ndarray, np.ndarray]:
        """Iterator over all the particles in the file

        Returns
        -------
        Tuple[np.ndarray, np.ndarray, np.ndarray, np.ndarray]
            1D arrays containing time stamps, x position, y position, z position.
        """
        id = 0
        while id<=self._max_id:
            if len(self.get_time_by_id(id)>0):
                yield (self.get_time_by_id(id),self.get_x_by_id(id),self.get_y_by_id(id),self.get_z_by_id(id))
            id += 1


# Load some data saved from Ringmind.
data = RingmindShearingBoxData()
data.load_particles("Ringmind/particles.csv")

# Iterate over all the particles in the file - plot the trajectories in
# blue and the start points in orange.
for (t,x,y,z) in data:
    plt.plot(y,x,"tab:blue")
    plt.plot([y[0]],[x[0]],"o", color="tab:orange")

plt.show()