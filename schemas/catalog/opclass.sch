# Catalog queries for operator class
# CAUTION: Do not modify this file unless you know what you are doing.
#          Code generation can be broken if incorrect changes are made.

%if @{list} %then
  [SELECT op.oid, opcname AS name FROM pg_opclass AS op ]

  %if @{schema} %then
    [ LEFT JOIN pg_namespace AS ns ON op.opcnamespace = ns.oid
       WHERE ns.nspname = ] '@{schema}'
  %end
%else
    %if @{attribs} %then
      [SELECT op.oid, op.opcname AS name, op.opcnamespace AS schema, op.opcowner AS owner,
              op.opcfamily AS family, op.opcintype AS type, op.opcdefault AS default,
              op.opckeytype AS storage, ]

      (@{comment}) [ AS comment, ]
      (@{from-extension}) [ AS from_extension_bool ]

      [ FROM pg_opclass AS op ]

      %if @{schema} %then
	[ LEFT JOIN pg_namespace AS ns ON op.opcnamespace = ns.oid ]
      %end

	%if @{filter-oids} %or @{schema} %then
	[ WHERE ]
	  %if @{filter-oids} %then
	   [ op.oid IN (] @{filter-oids} )

	    %if @{schema} %then
	      [ AND ]
	    %end
	  %end

	  %if @{schema} %then
	   [ ns.nspname = ] '@{schema}'
	  %end
       %end
    %end
%end