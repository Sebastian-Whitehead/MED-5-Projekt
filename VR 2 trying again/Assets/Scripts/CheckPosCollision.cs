using System;
using System.Collections;
using System.Collections.Generic;
using Unity.VisualScripting;
using UnityEngine;

public class CheckPosCollision : MonoBehaviour
{
    private Renderer _renderer;
    public GameObject target;
    private bool _collisionState = false;

    private void Start()
    {
        _renderer = GetComponent<Renderer>();
    }

    private void OnTriggerEnter(Collider col)
    {
        if (col.name == target.name)
        {
            //Debug.Log(" Correct collision!");
            _renderer.material.color = Color.green;
            _collisionState = true;
        }
    }

    private void OnTriggerExit(Collider col)
    {
        _renderer.material.color = Color.red;
        _collisionState = false;
    }

    public bool CheckCollision()
    {
        return _collisionState;
    }
}
