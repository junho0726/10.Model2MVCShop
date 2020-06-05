package com.model2.mvc.web.product;

import java.util.HashMap;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import org.codehaus.jackson.annotate.JsonIgnoreProperties;
import org.codehaus.jackson.map.ObjectMapper;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Qualifier;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

import com.model2.mvc.common.Page;
import com.model2.mvc.common.Search;
import com.model2.mvc.service.domain.Product;
import com.model2.mvc.service.domain.User;
import com.model2.mvc.service.product.ProductService;
import com.model2.mvc.service.user.UserService;


//==> 회원관리 RestController
@RestController
@RequestMapping("/product/*")
public class ProductRestController {
	
	///Field
	@Autowired
	@Qualifier("productServiceImpl")
	private ProductService productService;
	//setter Method 구현 않음
		
	public ProductRestController(){
		System.out.println(this.getClass());
	}

	@RequestMapping(value="json/addProduct", method = RequestMethod.POST)
	public Product addProduct( @RequestBody Product product ) throws Exception {

		System.out.println("/product/addProduct : POST");
		
		product.setManuDate(product.getManuDate().replace("-", ""));
		productService.addProduct(product);
	
		return product;
	}
	
	
	@RequestMapping( value="json/getProduct/{prodNo}", method=RequestMethod.GET )
	public Product getProduct( @PathVariable int prodNo ) throws Exception{
		
		System.out.println("/product/json/getProduct : GET");
		
		return productService.getProduct(prodNo);
	}


//	@RequestMapping( value="json/getProduct/{prodNo}", method=RequestMethod.POST )
//	public Product getProduct( @PathVariable int prodNo ) throws Exception{
//		
//		System.out.println("/product/json/getProduct : POST");
//		
//		return productService.getProduct(prodNo);
//	}
	
	@RequestMapping(value ="json/updateProductView/{prodNo}", method=RequestMethod.GET)
	public Product updateProductView(@PathVariable int prodNo ) throws Exception{

		System.out.println("/product/json/updateProductView: GET");

		return productService.getProduct(prodNo);
	}
	
	@RequestMapping(value="json/updateProduct", method=RequestMethod.POST)
	public Product updateProduct(@RequestBody Product product) throws Exception{

		System.out.println("/product/json/updateProduct: POST");
		product.setManuDate(product.getManuDate().replace("-", ""));
		productService.updateProduct(product);
		
		return product;
	}
	
//	@RequestMapping(value="json/listProduct", method=RequestMethod.GET)
//	public Map listProduct(@RequestBody Search search) throws Exception{
//		int pageSize = 3;
//		int pageUnit = 5;
//
//		System.out.println("/product/json/listProduct: GET");
//		if(search.getCurrentPage() ==0 ){
//			search.setCurrentPage(1);
//		}
//		
//		if(search.getSearchCondition() ==null) {
//			search.setSearchCondition("0");
//		}
//		
//		if(search.getSearchKeyword()==null) {
//			search.setSearchKeyword("");
//		}
//		System.out.println("search"+search);
//		search.setPageSize(pageSize);
//		
//		// Business logic 수행
//		Map<String , Object> map=productService.getProductList(search);
//		
//		Page resultPage = new Page( search.getCurrentPage(), ((Integer)map.get("totalCount")).intValue(), pageUnit, pageSize);
//		System.out.println(resultPage);
//
//		return map;
//	}
	
	@RequestMapping(value="json/listProduct", method=RequestMethod.POST)
	public Map listProduct(@RequestBody Search search) throws Exception{
		int pageSize = 3;
		int pageUnit = 5;

		System.out.println("/product/json/listProduct: POST");
		if(search.getCurrentPage() ==0 ){
			search.setCurrentPage(1);
		}
		
		if(search.getSearchCondition() ==null) {
			search.setSearchCondition("0");
		}
		
		if(search.getSearchKeyword()==null) {
			search.setSearchKeyword("");
		}
		System.out.println("search"+search);
		search.setPageSize(pageSize);
		
		// Business logic 수행
		Map<String , Object> map=productService.getProductList(search);
		
		Page resultPage = new Page( search.getCurrentPage(), ((Integer)map.get("totalCount")).intValue(), pageUnit, pageSize);
		System.out.println(resultPage);

		return map;
	}
}