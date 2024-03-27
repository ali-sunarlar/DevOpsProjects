package com.example.demo.service;

import com.example.demo.entity.Customer;
import com.example.demo.entity.dto.CustomerAddDto;
import com.example.demo.repository.CustomerRepository;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
public class CustomerServiceImpl {
    private final CustomerRepository customerRepository;
    public CustomerServiceImpl(CustomerRepository customerRepository){
        this.customerRepository=customerRepository;

    }

    public void addCustomer(CustomerAddDto customer){
        this.customerRepository.save(convertDtoToEntity(customer));
    }
    public List<Customer> listCustomer(){
        return this.customerRepository.findAll();
    }
    private Customer convertDtoToEntity(CustomerAddDto customerAddDto){
        Customer customer = new Customer();
        customer.setName(customerAddDto.getName());
        customer.setLastname(customerAddDto.getLastname());
        return customer;
    }

}
