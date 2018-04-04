package entities;

import javax.persistence.*;
import java.util.Collection;

@SuppressWarnings("RedundantIfStatement")
@NamedQuery(name = "Category.getAll", query = "SELECT c FROM Category c")
@Entity
public class Category {

    private Integer categoryId;
    private String categoryName;
    private Collection<Type> typesByCategoryId;

    @Id
    @Column(name = "category_id", nullable = false)
    public Integer getCategoryId() {
        return categoryId;
    }

    public void setCategoryId(Integer categoryId) {
        this.categoryId = categoryId;
    }

    @Basic
    @Column(name = "category_name", nullable = false, length = 50)
    public String getCategoryName() {
        return categoryName;
    }

    public void setCategoryName(String categoryName) {
        this.categoryName = categoryName;
    }

    @Override
    public boolean equals(Object o) {
        if (this == o) return true;
        if (o == null || getClass() != o.getClass()) return false;

        Category category = (Category) o;

        if (categoryId != null ? !categoryId.equals(category.categoryId) : category.categoryId != null) return false;
        if (categoryName != null ? !categoryName.equals(category.categoryName) : category.categoryName != null)
            return false;

        return true;
    }

    @Override
    public int hashCode() {
        int result = categoryId != null ? categoryId.hashCode() : 0;
        result = 31 * result + (categoryName != null ? categoryName.hashCode() : 0);
        return result;
    }

    @OneToMany(mappedBy = "categoryByCategoryId")
    public Collection<Type> getTypesByCategoryId() {
        return typesByCategoryId;
    }

    public void setTypesByCategoryId(Collection<Type> typesByCategoryId) {
        this.typesByCategoryId = typesByCategoryId;
    }
}
