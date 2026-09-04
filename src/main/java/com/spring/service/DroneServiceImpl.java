package com.spring.service;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.spring.dto.DroneDTO;
import com.spring.mapper.DroneMapper;

@Service
public class DroneServiceImpl implements DroneService {
	 
	@Autowired
	private DroneMapper droneMapper;

	@Override
	public DroneDTO getDroneById(String droneId) {
		return droneMapper.findByDroneId(droneId);
	}

	@Override
	public List<DroneDTO> getDroneList() {
		return droneMapper.findAllDrones();
	}

	@Override
	public boolean registerDrone(DroneDTO drone) {
		int droneResult = droneMapper.insertDrone(drone);
		
		return droneResult > 0;
	}

	@Override
	public boolean modifyDrone(DroneDTO drone) {
		return droneMapper.updateDrone(drone) > 0;
	}

	@Override
	public int getTotalDroneCount() {
		return droneMapper.getTotalDroneCount();
	}
}
