package com.ssafy.db.entity;

import static com.querydsl.core.types.PathMetadataFactory.*;

import com.querydsl.core.types.dsl.*;

import com.querydsl.core.types.PathMetadata;
import javax.annotation.Generated;
import com.querydsl.core.types.Path;
import com.querydsl.core.types.dsl.PathInits;


/**
 * QTile is a Querydsl query type for Tile
 */
@Generated("com.querydsl.codegen.EntitySerializer")
public class QTile extends EntityPathBase<Tile> {

    private static final long serialVersionUID = 846503280L;

    private static final PathInits INITS = PathInits.DIRECT2;

    public static final QTile tile = new QTile("tile");

    public final NumberPath<Integer> area = createNumber("area", Integer.class);

    public final StringPath buyerAdr = createString("buyerAdr");

    public final StringPath image = createString("image");

    public final QPlanet planet;

    public final NumberPath<Double> price = createNumber("price", Double.class);

    public final StringPath tid = createString("tid");

    public final StringPath tokenId = createString("tokenId");

    public final DateTimePath<java.time.LocalDateTime> tradeDate = createDateTime("tradeDate", java.time.LocalDateTime.class);

    public QTile(String variable) {
        this(Tile.class, forVariable(variable), INITS);
    }

    public QTile(Path<? extends Tile> path) {
        this(path.getType(), path.getMetadata(), PathInits.getFor(path.getMetadata(), INITS));
    }

    public QTile(PathMetadata metadata) {
        this(metadata, PathInits.getFor(metadata, INITS));
    }

    public QTile(PathMetadata metadata, PathInits inits) {
        this(Tile.class, metadata, inits);
    }

    public QTile(Class<? extends Tile> type, PathMetadata metadata, PathInits inits) {
        super(type, metadata, inits);
        this.planet = inits.isInitialized("planet") ? new QPlanet(forProperty("planet")) : null;
    }

}

