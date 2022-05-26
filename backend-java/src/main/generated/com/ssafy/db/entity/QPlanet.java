package com.ssafy.db.entity;

import static com.querydsl.core.types.PathMetadataFactory.*;

import com.querydsl.core.types.dsl.*;

import com.querydsl.core.types.PathMetadata;
import javax.annotation.Generated;
import com.querydsl.core.types.Path;
import com.querydsl.core.types.dsl.PathInits;


/**
 * QPlanet is a Querydsl query type for Planet
 */
@Generated("com.querydsl.codegen.EntitySerializer")
public class QPlanet extends EntityPathBase<Planet> {

    private static final long serialVersionUID = 1628771290L;

    public static final QPlanet planet = new QPlanet("planet");

    public final StringPath content = createString("content");

    public final NumberPath<Double> diameter = createNumber("diameter", Double.class);

    public final StringPath galaxy = createString("galaxy");

    public final NumberPath<Double> mass = createNumber("mass", Double.class);

    public final StringPath name = createString("name");

    public final NumberPath<Long> pid = createNumber("pid", Long.class);

    public final ListPath<Tile, QTile> tiles = this.<Tile, QTile>createList("tiles", Tile.class, QTile.class, PathInits.DIRECT2);

    public final NumberPath<Integer> totalCell = createNumber("totalCell", Integer.class);

    public QPlanet(String variable) {
        super(Planet.class, forVariable(variable));
    }

    public QPlanet(Path<? extends Planet> path) {
        super(path.getType(), path.getMetadata());
    }

    public QPlanet(PathMetadata metadata) {
        super(Planet.class, metadata);
    }

}

