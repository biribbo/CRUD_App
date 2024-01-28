package com.example.crudApp.logic;

import com.example.crudApp.dto.ProductReadModel;
import com.example.crudApp.dto.ProductWriteModel;
import com.example.crudApp.model.Category;
import com.example.crudApp.model.Comment;
import com.example.crudApp.model.Product;
import com.example.crudApp.repository.CategoryRepository;
import com.example.crudApp.repository.ProductRepository;
import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.context.SpringBootTest;

import java.util.*;

import static org.assertj.core.api.Assertions.assertThat;
import static org.junit.jupiter.api.Assertions.*;

@SpringBootTest
class ProductServiceTest {
    @Autowired
    private ProductRepository repo;

    @Autowired
    private CategoryRepository categoryRepo;

    @Autowired
    private ProductService service;

    @Test
    public void createProductTest() {
        ProductWriteModel toCreate1 = new ProductWriteModel("Baldur's Gate 3", "Very cool RPG", "https://image.api.playstation.com/vulcan/ap/rnd/202302/2321/3098481c9164bb5f33069b37e49fba1a572ea3b89971ee7b.jpg");
        ProductWriteModel toCreate2 = new ProductWriteModel("Eleiko IPF Competition Set", "The bar and plates from 0.25 kg to 25 kg", "https://www.pullumsports.co.uk/cdn/shop/files/EleikoIPF285kgSet_1024x1024@2x.webp?v=1698914953");
        ProductWriteModel toCreate3 = new ProductWriteModel("Competition Bench", "Competition bench with wight storage", "https://www.elitefts.com/media/catalog/product/cache/36d7bfb33e8965fc8880f222555067c7/s/i/signature-competition-bench-r.jpg");
        ProductWriteModel toCreate4 = new ProductWriteModel("AMD Ryzen 5 7600X", "Good AM5 CPU", "https://cdn.x-kom.pl/i/setup/images/prod/big/product-new-big,,2023/1/pr_2023_1_25_12_49_50_693_03.jpg");
        ProductWriteModel toCreate5 = new ProductWriteModel("Presonus Eris e3.5", "A pair of speakers for your PC or home gym", "https://thumbs.static-thomann.de/thumb/padthumb600x600/pics/bdb/_57/572877/18550693_800.jpg");

        service.createProduct(toCreate1);
        service.createProduct(toCreate2);
        service.createProduct(toCreate3);
        service.createProduct(toCreate4);
        service.createProduct(toCreate5);

        //assertEquals(5, service.readAll(0).c);
    }

    @Test
    public void updateTest() {
        ProductWriteModel toUpdate = new ProductWriteModel("Baldur's Gate 3 Digital", "Very cool RPG, digital version", "https://image.api.playstation.com/vulcan/ap/rnd/202302/2321/3098481c9164bb5f33069b37e49fba1a572ea3b89971ee7b.jpg");
        ProductReadModel updated = service.updateProduct(toUpdate, 21);

        assertThat(updated.getTitle()).isEqualTo(toUpdate.getTitle());
        assertThat(updated.getDescription()).isEqualTo(toUpdate.getDescription());
    }

    @Test
    public void deleteAndPaginationTest() {
        ProductWriteModel toCreate1 = new ProductWriteModel("test", "test", "https://ijp.pan.pl/wp-content/uploads/2020/04/test.jpg");
        ProductWriteModel toCreate2 = new ProductWriteModel("test", "test", "https://ijp.pan.pl/wp-content/uploads/2020/04/test.jpg");
        ProductWriteModel toCreate3 = new ProductWriteModel("test", "test", "https://ijp.pan.pl/wp-content/uploads/2020/04/test.jpg");
        ProductWriteModel toCreate4 = new ProductWriteModel("test", "test", "https://ijp.pan.pl/wp-content/uploads/2020/04/test.jpg");
        ProductWriteModel toCreate5 = new ProductWriteModel("test", "test", "https://ijp.pan.pl/wp-content/uploads/2020/04/test.jpg");
        ProductWriteModel toCreate6 = new ProductWriteModel("test", "test", "https://ijp.pan.pl/wp-content/uploads/2020/04/test.jpg");

        service.createProduct(toCreate1);
        service.createProduct(toCreate2);
        service.createProduct(toCreate3);
        service.createProduct(toCreate4);
        service.createProduct(toCreate5);
        service.createProduct(toCreate6);

        service.deleteProduct(38);
        service.deleteProduct(39);
        service.deleteProduct(40);
        service.deleteProduct(41);
        service.deleteProduct(42);
        service.deleteProduct(43);

        assertEquals(10, service.readAllWithDeleted(0).size());
        assertEquals(10, service.readAllWithDeleted(1).size());
        assertEquals(3, service.readAllWithDeleted(2).size());
    }

    @Test
    public void searchTest() {
        List<ProductReadModel> searchResult = service.readProductsByName("Ryzen");
        assertThat(searchResult.size()).isEqualTo(1);

        List<ProductReadModel> searchResult2 = service.readProductsByName("test");
        assertThat(searchResult2.size()).isEqualTo(18);
    }

    @Test
    public void assignCategoriesTest() {
        Category videoGames = categoryRepo.findById(7)
                .orElse(null);
        Category gymEquip = categoryRepo.findById(8)
                .orElse(null);
        Category pcParts = categoryRepo.findById(9)
                .orElse(null);
        Set<Category> emptySet = new HashSet<>();

        Product product1 = repo.findById(21)
                .orElse(null);
        Product product2 = repo.findById(22)
                .orElse(null);
        Product product3 = repo.findById(23)
                .orElse(null);
        Product product4 = repo.findById(24)
                .orElse(null);
        Product product5 = repo.findById(25)
                .orElse(null);
        Product testProduct = repo.findById(44)
                .orElse(null);

        Set<Category> videoGamesSet = Collections.singleton(videoGames);
        Set<Category> gymEquipSet = Collections.singleton(gymEquip);
        Set<Category> pcPartsSet = Collections.singleton(pcParts);
        Set<Category> gymAndPcPartsSet = new HashSet<>(Arrays.asList(gymEquip, pcParts));

        service.manageCategories(videoGamesSet, emptySet, 21);
        service.manageCategories(gymEquipSet, emptySet, 22);
        service.manageCategories(gymEquipSet, emptySet, 23);
        service.manageCategories(pcPartsSet, emptySet, 24);
        service.manageCategories(gymAndPcPartsSet, emptySet, 25);

        assertThat(product1.getCategories().size()).isEqualTo(1);
        assertThat(product2.getCategories().size()).isEqualTo(1);
        assertThat(product3.getCategories().size()).isEqualTo(1);
        assertThat(product4.getCategories().size()).isEqualTo(1);
        assertThat(product5.getCategories().size()).isEqualTo(2);

        assertThat(videoGames.getProducts().size()).isEqualTo(2);
        assertThat(gymEquip.getProducts().size()).isEqualTo(3);
        assertThat(pcParts.getProducts().size()).isEqualTo(2);

        service.manageCategories(gymAndPcPartsSet, emptySet, 44);
        service.manageCategories(emptySet, gymEquipSet, 44);

        System.out.println(testProduct);
        System.out.println(gymEquip.getProducts());
        System.out.println(pcParts.getProducts());
        assertThat(videoGames.getProducts().size()).isEqualTo(2);
        assertThat(gymEquip.getProducts().size()).isEqualTo(3);
        assertThat(pcParts.getProducts().size()).isEqualTo(3);

        assertThat(testProduct.getCategories().size()).isEqualTo(2);
    }

    @Test
    public void deleteWithCommentsTest() {
        service.deleteProduct(44);

        Product testProduct = repo.findById(44)
                .orElse(null);

        assertThat(testProduct.isDeleted()).isTrue();
        for (Comment comment : testProduct.getComments()) {
            assertThat(comment.isDeleted()).isTrue();
        }
    }
}