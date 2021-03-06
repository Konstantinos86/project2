package entities;

import javax.persistence.*;
import java.util.Collection;

@SuppressWarnings("RedundantIfStatement")
@NamedQuery(name = "Unit.getAll", query = "SELECT u FROM Unit u")
@Entity
public class Unit {

    private Integer unitId;
    private String unitName;
    private Collection<Product> productsByUnitId;

    @Id
    @Column(name = "unit_id", nullable = false)
    public Integer getUnitId() {
        return unitId;
    }

    public void setUnitId(Integer unitId) {
        this.unitId = unitId;
    }

    @Basic
    @Column(name = "unit_name", nullable = false, length = 50)
    public String getUnitName() {
        return unitName;
    }

    public void setUnitName(String unitName) {
        this.unitName = unitName;
    }

    @Override
    public boolean equals(Object o) {
        if (this == o) return true;
        if (o == null || getClass() != o.getClass()) return false;

        Unit unit = (Unit) o;

        if (unitId != null ? !unitId.equals(unit.unitId) : unit.unitId != null) return false;
        if (unitName != null ? !unitName.equals(unit.unitName) : unit.unitName != null) return false;

        return true;
    }

    @Override
    public int hashCode() {
        int result = unitId != null ? unitId.hashCode() : 0;
        result = 31 * result + (unitName != null ? unitName.hashCode() : 0);
        return result;
    }

    @OneToMany(mappedBy = "unitByUnitId")
    public Collection<Product> getProductsByUnitId() {
        return productsByUnitId;
    }

    public void setProductsByUnitId(Collection<Product> productsByUnitId) {
        this.productsByUnitId = productsByUnitId;
    }
}
