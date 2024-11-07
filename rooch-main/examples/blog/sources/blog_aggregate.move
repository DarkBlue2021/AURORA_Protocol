// Copyright (c) RoochNetwork
// SPDX-License-Identifier: Apache-2.0

// <autogenerated>
//   This file was generated by dddappp code generator.
//   Any changes made to this file manually will be lost next time the file is regenerated.
// </autogenerated>

module rooch_examples::blog_aggregate {
    use moveos_std::object::ObjectID;
    
    use moveos_std::object::{Self, Object};
    use rooch_examples::blog;
    use rooch_examples::blog_add_article_logic;
    use rooch_examples::blog_create_logic;
    use rooch_examples::blog_delete_logic;
    use rooch_examples::blog_remove_article_logic;
    use rooch_examples::blog_update_logic;
    use rooch_examples::article::Article;
    use std::string::String;

    friend rooch_examples::article_create_logic;
    friend rooch_examples::article_delete_logic;

    public(friend) fun add_article(
        
        article_obj: Object<Article>,
    ) {
        let blog = blog::borrow_blog();
        let article_id = object::id(&article_obj);
        let article_added_to_blog = blog_add_article_logic::verify(
            article_id,
            blog,
        );
        let mut_blog = blog::borrow_mut_blog();
        blog_add_article_logic::mutate(
            &article_added_to_blog,
            article_obj,
            mut_blog,
        );
        blog::update_version(mut_blog);
        blog::emit_article_added_to_blog(article_added_to_blog);
    }

    public(friend) fun remove_article(
        
        article_id: ObjectID,
    ) : Object<Article> {
        let blog = blog::borrow_blog();
        let article_removed_from_blog = blog_remove_article_logic::verify(
            article_id,
            blog,
        );
        let mut_blog = blog::borrow_mut_blog();
        let article_obj = blog_remove_article_logic::mutate(
            &article_removed_from_blog,
            mut_blog,
        );
        blog::update_version(mut_blog);
        blog::emit_article_removed_from_blog(article_removed_from_blog);
        article_obj
    }

    public entry fun create(
        
        account: &signer,
        name: String,
    ) {
        let blog_created = blog_create_logic::verify(
            
            account,
            name,
        );
        let blog = blog_create_logic::mutate(
            
            account,
            &blog_created,
        );
        blog::add_blog(account, blog);
        blog::emit_blog_created(blog_created);
    }

    public entry fun update(
        
        account: &signer,
        name: String,
    ) {
        let blog = blog::remove_blog();
        let blog_updated = blog_update_logic::verify(
            
            account,
            name,
            &blog,
        );
        let updated_blog = blog_update_logic::mutate(
            
            account,
            &blog_updated,
            blog,
        );
        blog::update_version_and_add(account, updated_blog);
        blog::emit_blog_updated(blog_updated);
    }

    public entry fun delete(
        
        account: &signer,
    ) {
        let blog = blog::remove_blog();
        let blog_deleted = blog_delete_logic::verify(
            
            account,
            &blog,
        );
        let updated_blog = blog_delete_logic::mutate(
            
            account,
            &blog_deleted,
            blog,
        );
        blog::drop_blog(updated_blog);
        blog::emit_blog_deleted(blog_deleted);
    }

}
