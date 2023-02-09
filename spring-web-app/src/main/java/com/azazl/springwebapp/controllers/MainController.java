package com.azazl.springwebapp.controllers;

import com.azazl.springwebapp.entities.Product;
import com.azazl.springwebapp.services.ProductService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import java.util.List;

@Controller
public class MainController {
    private ProductService productService;
    @Autowired
    public void setProductService(ProductService productService) {
        this.productService = productService;
    }

    @GetMapping("/index")
    public String homePage(){
        return "index";
    }
    @GetMapping("/shop")
    public String shopPage(Model model){
        List<Product> allProduct = productService.getAllProducts();
        model.addAttribute("products", allProduct);
        return "shop";
    }
    @GetMapping("/details/{id}")
    public String detailsPage(Model model, @PathVariable("id") Long id){
        Product selectproduct = productService.getProductById(id);
        model.addAttribute("selectedProduct", selectproduct);
        return "details";
    }
    @GetMapping("/products/delete/{id}")
    public String deleteProductById(@PathVariable("id") Long id){
        productService.deleteProductById(id);
        return "redirect:/shop";
    }
    @GetMapping("/data")
    @ResponseBody
    public String getData(@RequestParam("serial") Long serial, @RequestParam("number") Long number){
        return "S/N: "+ serial+" / " + number;
    }
}
