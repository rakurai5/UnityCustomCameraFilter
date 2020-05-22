using UnityEngine;

[ExecuteInEditMode]
public class RainWindowEffect : CustomImageEffectBase
{
    #region Fields
    [SerializeField]
    private float Size = 1.0f;
    [SerializeField]
    private float TimeScale = 1.0f;
    [SerializeField]
    [Range(1, 256)]
    private float PosterizeTime = 1.0f;
    [SerializeField]
    [Range(-5.0f, 5.0f)]
    private float Distortion = 1.0f;
    [SerializeField]
    private float RotateUV = 0.0f;

    [SerializeField]
    private bool SoftBlurToggle;
    [SerializeField]
    [Range(0.0f, 1.0f)]
    private float Blur = 0.5f;

    #endregion

    #region Properties

    public override string ShaderName
    {
        get { return "CustomFilter/RainWindow"; }
    }

    #endregion

    #region Methods

    protected override void UpdateMaterial()
    {

        Material.SetFloat("_Size", Size);
        Material.SetFloat("_T", TimeScale);
        Material.SetFloat("_Posterize", PosterizeTime);
        Material.SetFloat("_Distortion", Distortion);
        Material.SetFloat("_rotate", RotateUV);
        if (SoftBlurToggle == true)
        {
            Material.EnableKeyword("_APPLY_SOFTBLUR_ON");
        }
        else if (SoftBlurToggle == false)
        {
            Material.DisableKeyword("_APPLY_SOFTBLUR_ON");
        }

        Material.SetFloat("_Blur", Blur);

    }

    #endregion

}