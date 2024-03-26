package com.example.demo.controller;

import com.example.demo.entity.Customer;
import com.example.demo.entity.dto.CustomerAddDto;
import com.example.demo.service.CustomerServiceImpl;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("customer/")
public class CustomerController {
    private final CustomerServiceImpl customerService;

    public CustomerController(CustomerServiceImpl customerService) {
        this.customerService = customerService;
    }

    @GetMapping("getAllCustomer")
    public List<Customer> getAllCustomer(){
        return this.customerService.listCustomer();
    }
    @PostMapping("addCustomer")
    public void addCustomer(@RequestBody CustomerAddDto customer){
        this.customerService.addCustomer(customer);
    }
}
