CREATE TABLE book (
    book_id integer NOT NULL PRIMARY KEY,
    title character varying(255) NOT NULL,
    description text NOT NULL,
    author character varying(255) NOT NULL,
    price numeric(2,0) NOT NULL,
    stock integer NOT NULL DEFAULT 0 CHECK (stock >= 0)
);

CREATE TABLE customer (
    customer_id integer NOT NULL PRIMARY KEY,
    email character varying(255) NOT NULL UNIQUE,
    first_name character varying(100) NOT NULL,
    last_name character varying(100) NOT NULL,
    country character varying(100) NOT NULL,
    city character varying(100) NOT NULL,
    address character varying(100) NOT NULL,
    phone character varying(100)
);

CREATE TABLE invoice (
    invoice_id integer NOT NULL PRIMARY KEY,
    order_id integer NOT NULL,
    store_id integer NOT NULL,
    customer_id integer NOT NULL,
    total numeric(2,0) NOT NULL,
    tax numeric(2,0) NOT NULL,
    created date DEFAULT now() NOT NULL
);

CREATE TABLE invoice_item (
    book_id integer NOT NULL REFERENCES book(book_id),
    invoice_id integer NOT NULL REFERENCES invoice(invoice_id),
    quantity integer NOT NULL,
    invoice_price numeric(2,0) NOT NULL,
	PRIMARY KEY (book_id, invoice_id)
);

CREATE TABLE "order" (
    order_id integer NOT NULL PRIMARY KEY,
    customer_id integer NOT NULL,
    status character varying(50) DEFAULT 'cart'::character varying NOT NULL,
    created date DEFAULT now() NOT NULL,
    updated date
);

CREATE TABLE order_item (
    order_id integer NOT NULL REFERENCES "order"(order_id),
    book_id integer NOT NULL REFERENCES book(book_id),
    quantity integer NOT NULL,
	PRIMARY KEY (order_id, book_id)
);

CREATE TABLE store (
    store_id integer NOT NULL PRIMARY KEY,
    name character varying(100) DEFAULT 'Bookshop'::character varying NOT NULL UNIQUE,
    description character varying(100),
    tax_id character varying(100) DEFAULT 0 NOT NULL,
    address character varying(255) NOT NULL,
    phone integer NOT NULL,
    email character varying(255) NOT NULL UNIQUE,
    url character varying(255)
);
