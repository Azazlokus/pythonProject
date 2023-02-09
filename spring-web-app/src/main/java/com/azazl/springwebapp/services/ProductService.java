package com.azazl.springwebapp.services;

import com.azazl.springwebapp.entities.Product;
import com.azazl.springwebapp.repositories.ProductRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
public class ProductService {
    private ProductRepository productRepository;
    @Autowired
    public void setProductRepository(ProductRepository productRepository) {
        this.productRepository = productRepository;
    }
    @Autowired
    public List<Product> getAllProducts(){
        return productRepository.getProducts();
    }
    public Product getProductById(Long id){
    return productRepository.getProducts().get(id.intValue()-1);
   }
    public void deleteProductById(Long id){
      productRepository.deleteByUd(id);
    }
}

