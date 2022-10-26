using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class VRStartingPos : MonoBehaviour
{
    public CheckPosCollision leftHandZone;
    public CheckPosCollision rightHandZone;
    
    public GameObject viewTarget;
    private Renderer _targetRenderer;
    private bool _lookingAt = false;

    // Start is called before the first frame update
    void Start()
    {
        _targetRenderer = viewTarget.GetComponent<Renderer>();
    }

    // Update is called once per frame
    void Update()
    {
        var ray = new Ray(this.transform.position, this.transform.forward);
        RaycastHit hit;
        if(Physics.Raycast(ray, out hit))
        {
            if (viewTarget.name == hit.transform.gameObject.name)
            {
                viewTarget.GetComponent<Renderer>();
                _targetRenderer.material.color = Color.green;
                _lookingAt = true;
                CheckStartingPos();
            }
            else
            {
                _targetRenderer.material.color = Color.red;
                _lookingAt = false;
            
            }
        }
    }

    void CheckStartingPos()
    {
        if (leftHandZone.CheckCollision() && rightHandZone.CheckCollision() && _lookingAt)
        {
            Debug.Log("All requirements met");
            // Change Scene
        }
    }
}
