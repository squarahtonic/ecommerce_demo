include: "/views/distribution_centers.view.lkml"

view: +distribution_centers {
  dimension: id {
    primary_key: yes
  }

  dimension: latitude {
  }

  dimension: longitude {
    type: number
  }

  dimension: location {
  }

  dimension: name {
  }

}
