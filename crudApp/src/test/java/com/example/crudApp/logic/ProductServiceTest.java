package com.example.crudApp.logic;

import com.example.crudApp.dto.ProductWriteModel;
import com.example.crudApp.model.Category;
import com.example.crudApp.model.Product;
import com.example.crudApp.repository.CategoryRepository;
import com.example.crudApp.repository.ProductRepository;
import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.context.SpringBootTest;

import java.util.Arrays;
import java.util.Collections;
import java.util.HashSet;
import java.util.Set;

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
        Set<Category> emptySet = new HashSet<>();

        ProductWriteModel toCreate1 = new ProductWriteModel("Baldur's Gate 3", "Very cool RPG", "https://image.api.playstation.com/vulcan/ap/rnd/202302/2321/3098481c9164bb5f33069b37e49fba1a572ea3b89971ee7b.jpg", emptySet);
        ProductWriteModel toCreate2 = new ProductWriteModel("Eleiko IPF Competition Set", "The bar and plates from 0.25 kg to 25 kg", "https://www.pullumsports.co.uk/cdn/shop/files/EleikoIPF285kgSet_1024x1024@2x.webp?v=1698914953", emptySet);
        ProductWriteModel toCreate3 = new ProductWriteModel("Competition Bench", "Competition bench with wight storage", "https://www.elitefts.com/media/catalog/product/cache/36d7bfb33e8965fc8880f222555067c7/s/i/signature-competition-bench-r.jpg", emptySet);
        ProductWriteModel toCreate4 = new ProductWriteModel("AMD Ryzen 5 7600X", "Good AM5 CPU", "https://cdn.x-kom.pl/i/setup/images/prod/big/product-new-big,,2023/1/pr_2023_1_25_12_49_50_693_03.jpg", emptySet);
        ProductWriteModel toCreate5 = new ProductWriteModel("Presonus Eris e3.5", "A pair of speakers for your PC or home gym", "https://thumbs.static-thomann.de/thumb/padthumb600x600/pics/bdb/_57/572877/18550693_800.jpg", emptySet);

        service.createProduct(toCreate1);
        service.createProduct(toCreate2);
        service.createProduct(toCreate3);
        service.createProduct(toCreate4);
        service.createProduct(toCreate5);

        assertEquals(5, service.readAll(0).size());
    }

    @Test
    public void assignCategoriesTest() {
        Category videoGames = categoryRepo.findById(7)
                .orElse(null);
        Category gymEquip = categoryRepo.findById(8)
                .orElse(null);
        Category pcParts = categoryRepo.findById(9)
                .orElse(null);

        assertThat(videoGames).isNotNull();
        assertThat(gymEquip).isNotNull();
        assertThat(pcParts).isNotNull();

        Set<Category> videoGamesSet = Collections.singleton(videoGames);
        Set<Category> gymEquipSet = Collections.singleton(gymEquip);
        Set<Category> pcPartsSet = Collections.singleton(pcParts);
        Set<Category> gymAndPcPartsSet = new HashSet<>(Arrays.asList(gymEquip, pcParts));

        ProductWriteModel toUpdate1 = new ProductWriteModel("Baldur's Gate 3", "Very cool RPG", "https://image.api.playstation.com/vulcan/ap/rnd/202302/2321/3098481c9164bb5f33069b37e49fba1a572ea3b89971ee7b.jpg", videoGamesSet);
        ProductWriteModel toUpdate2 = new ProductWriteModel("Eleiko IPF Competition Set", "The bar and plates from 0.25 kg to 25 kg", "https://www.pullumsports.co.uk/cdn/shop/files/EleikoIPF285kgSet_1024x1024@2x.webp?v=1698914953", gymEquipSet);
        ProductWriteModel toUpdate3 = new ProductWriteModel("Competition Bench", "Competition bench with wight storage", "https://www.elitefts.com/media/catalog/product/cache/36d7bfb33e8965fc8880f222555067c7/s/i/signature-competition-bench-r.jpg", gymEquipSet);
        ProductWriteModel toUpdate4 = new ProductWriteModel("AMD Ryzen 5 7600X", "Good AM5 CPU", "https://cdn.x-kom.pl/i/setup/images/prod/big/product-new-big,,2023/1/pr_2023_1_25_12_49_50_693_03.jpg", pcPartsSet);
        ProductWriteModel toUpdate5 = new ProductWriteModel("Presonus Eris e3.5", "A pair of speakers for your PC or home gym", "https://thumbs.static-thomann.de/thumb/padthumb600x600/pics/bdb/_57/572877/18550693_800.jpg", gymAndPcPartsSet);

        service.updateProduct(toUpdate1, 11);
        service.updateProduct(toUpdate2, 12);
        service.updateProduct(toUpdate3, 13);
        service.updateProduct(toUpdate4, 14);
        service.updateProduct(toUpdate5, 15);

        Product updated = repo.findById(11)
                        .orElse(null);

        System.out.println(updated.getCategories());
        System.out.println(gymEquip.getProducts());

        assertEquals(1, updated.getCategories().size());
        assertThat(updated.getCategories().contains(videoGames)).isTrue();

        assertEquals(3, gymEquip.getProducts().size());
        assertEquals(2, pcParts.getProducts().size());
        assertEquals(1, videoGames.getProducts().size());
    }

    @Test
    public void deleteAndPaginationTest() {
        Set<Category> emptySet = new HashSet<>();

        ProductWriteModel toCreate1 = new ProductWriteModel("test", "test", "https://ijp.pan.pl/wp-content/uploads/2020/04/test.jpg", emptySet);
        ProductWriteModel toCreate2 = new ProductWriteModel("test", "test", "https://ijp.pan.pl/wp-content/uploads/2020/04/test.jpg", emptySet);
        ProductWriteModel toCreate3 = new ProductWriteModel("test", "test", "https://ijp.pan.pl/wp-content/uploads/2020/04/test.jpg", emptySet);
        ProductWriteModel toCreate4 = new ProductWriteModel("test", "test", "https://ijp.pan.pl/wp-content/uploads/2020/04/test.jpg", emptySet);
        ProductWriteModel toCreate5 = new ProductWriteModel("test", "test", "https://ijp.pan.pl/wp-content/uploads/2020/04/test.jpg", emptySet);
        ProductWriteModel toCreate6 = new ProductWriteModel("test", "test", "https://ijp.pan.pl/wp-content/uploads/2020/04/test.jpg", emptySet);

        service.createProduct(toCreate1);
        service.createProduct(toCreate2);
        service.createProduct(toCreate3);
        service.createProduct(toCreate4);
        service.createProduct(toCreate5);
        service.createProduct(toCreate6);

        service.deleteProduct(6);
        service.deleteProduct(7);
        service.deleteProduct(8);
        service.deleteProduct(9);
        service.deleteProduct(10);
        service.deleteProduct(11);

        assertEquals(10, service.readAllWithDeleted(0).size());
        assertEquals(1, service.readAllWithDeleted(1).size());
    }
}