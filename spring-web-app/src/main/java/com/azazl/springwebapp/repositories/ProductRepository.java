package com.azazl.springwebapp.repositories;

import com.azazl.springwebapp.entities.Product;
import jakarta.annotation.PostConstruct;
import org.springframework.stereotype.Component;

import java.util.ArrayList;
import java.util.List;

@Component
public class ProductRepository {
    private List<Product> products;

    public List<Product> getProducts() {
        return products;
    }
    @PostConstruct
    public void init(){
        products = new ArrayList<>();
        products.add(new Product(1L, "Milk", 20));
        products.add( new Product(2L, "Chess", 320));
        products.add(new Product(3L, "Eggs", 70));
    }
    public void deleteByUd(Long id){
        for(int i=0; i<products.size(); i++){
            if(products.get(i).getId().equals(id)){
                products.remove(i);
                return;
            }
        }
    }
}
